/* GenericArrayCollector.vala
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

using Gee;

private class Gpseq.Collectors.GenericArrayCollector<G> : Object, Collector<G,GenericArray<G>,GenericArray<G>> {
	public CollectorFeatures features {
		get {
			return 0;
		}
	}

	public GenericArray<G> create_accumulator () {
		return new GenericArray<G>();
	}

	public void accumulate (G g, GenericArray<G> a) {
		a.add(g);
	}

	public GenericArray<G> combine (GenericArray<G> a, GenericArray<G> b) {
		for (int i = 0; i < b.length; i++) {
			a.add(b[i]);
		}
		return a;
	}

	public GenericArray<G> finish (GenericArray<G> a) {
		return a;
	}
}
