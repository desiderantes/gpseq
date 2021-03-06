/* DefaultSupplier.vala
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
	/**
	 * Default supplier implementation.
	 */
	internal class DefaultSupplier<T> : Object, Supplier<T> {
		private SupplyFunc<T> _func;

		/**
		 * Creates a new default supplier.
		 * @param func a supply function
		 */
		public DefaultSupplier (owned SupplyFunc<T> func) {
			_func = (owned) func;
		}

		public T supply () {
			return _func();
		}
	}
}
