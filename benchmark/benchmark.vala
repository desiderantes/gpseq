/* benchmark.vala
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

private const int LENGTH = 16777216;

void main () {
	uint processors = get_num_processors();
	uint parallels = TaskEnv.get_default_task_env().executor.parallels;
	print("> CPU logical cores: %u\n", processors);
	print("> Executor parallelism: %u\n", parallels);
	print("> sizeof(gint): %u\n", (uint) sizeof(int));
	print("> sizeof(gpointer): %u\n", (uint) sizeof(void*));

	benchmark(1, (r) => {
		benchmark_chop(r);
		benchmark_collect(r);
		benchmark_complex(r);
		benchmark_filter(r);
		benchmark_find(r);
		benchmark_flat_map(r);
		benchmark_map(r);
		benchmark_max(r);
		benchmark_reduce(r);
		benchmark_sort(r);
	});
}
