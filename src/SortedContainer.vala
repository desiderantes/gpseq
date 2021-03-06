/* SortedContainer.vala
 *
 * Copyright (C) 2018  kosmolot (kosmolot17@yandex.com)
 *
 * This file is part of Gpseq.
 *
 * Gpseq is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or (at your
 * option) any later version.
 *
 * Gpseq is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
 * License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Gpseq.  If not, see <http://www.gnu.org/licenses/>.
 */

namespace Gpseq {
	/*
	 * A container which contains the elements of a input, sorted based on a
	 * compare function.
	 */
	internal class SortedContainer<G> : DefaultContainer<G> {
		private CompareDataFunc<G>? _compare;

		/**
		 * Creates a new sorted container.
		 * @param spliterator a spliterator that may or may not be a container
		 * @param parent the parent of the new container
		 * @param compare a //non-interfering// and //stateless// compare
		 * function
		 */
		public SortedContainer (Spliterator<G> spliterator, Container<G,void*> parent,
				owned CompareDataFunc<G> compare) {
			base(spliterator, parent, new Consumer<G>());
			_compare = (owned) compare;
		}

		private SortedContainer.copy (SortedContainer<G> container, Spliterator<G> spliterator) {
			base(spliterator, container.parent, container.consumer);
		}

		protected override DefaultContainer<G> make_container (Spliterator<G> spliterator) {
			return new SortedContainer<G>.copy(this, spliterator);
		}

		public override void start (Seq seq) {
			if (parent != null) parent.start(seq);
			sort(seq);
			set_parent(null);
		}

		private void sort (Seq seq) {
			G[] array = spliter_to_array();
			SubArray<G> sub = new SubArray<G>(array);
			int len = array.length;
			if (seq.is_parallel) {
				G[] temp_array = new G[len];
				SubArray<G> temp = new SubArray<G>(temp_array);
				Comparator<G> cmp = new Comparator<G>((owned) _compare);
				int threshold = seq.task_env.resolve_threshold(len, seq.task_env.executor.parallels);
				int max_depth = seq.task_env.resolve_max_depth(len, seq.task_env.executor.parallels);

				SortTask<G> task = new SortTask<G>(sub, temp, cmp, threshold, max_depth, seq.task_env.executor);
				task.fork();
				task.join_quietly();
				spliterator = new ArraySpliterator<G>((owned) array, 0, len);
			} else {
				sub.sort((owned) _compare);
				spliterator = new ArraySpliterator<G>((owned) array, 0, len);
			}
		}

		private G[] spliter_to_array () {
			G[] array;
			// NOTE. must check is_size_known first.
			// is_size_known could be changed after estimated_size call.
			if (!spliterator.is_size_known || spliterator.estimated_size < 0) {
				array = {}; // XXX use estimated_size
				spliterator.each((g) => {
					array += g;
				});
			} else if (spliterator.estimated_size > 0) {
				array = new G[spliterator.estimated_size];
				int i = 0;
				spliterator.each((g) => {
					array[i++] = g;
				});
			} else { // spliterator.estimated_size == 0
				array = {};
			}
			return array;
		}
	}
}
