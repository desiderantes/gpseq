/* benchmark-sort.vala
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

using Benchmarks;
using Gpseq;
using Gee;

void benchmark_sort (Reporter r) {
	r.group("sort", (r) => {
		r.report("qsort_with_data", (s) => {
			var array = create_rand_generic_int_array(LENGTH);
			var cmp = Functions.get_compare_func_for(typeof(int));
			s.start();
			qsort_with_data<int>(array.data, sizeof(void*), cmp);
		});

		r.report("GenericArray.sort_with_data", (s) => {
			var array = create_rand_generic_int_array(LENGTH);
			var cmp = Functions.get_compare_func_for(typeof(int));
			s.start();
			array.sort_with_data(cmp);
		});

		r.report("ArrayList.sort", (s) => {
			var list = new ArrayList<int>();
			for (int i = 0; i < LENGTH; i++) {
				list.add((int) Random.next_int());
			}
			s.start();
			list.sort();
		});

		r.report("Gpseq.parallel_sort", (s) => {
			var array = create_rand_generic_int_array(LENGTH);
			s.start();
			parallel_sort<int>(array.data);
		});
	});
}
