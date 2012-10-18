// file automatically generated - do not edit!
// matrix-matrix multiplication C = A * B^T
// matrix layouts: C...row_major, A...col_major, B...col_major
__kernel void prod_AT(
          __global const float * A,
          unsigned int A_row_start,
          unsigned int A_col_start,
          unsigned int A_row_size,
          unsigned int A_col_size,
          unsigned int A_internal_rows,
          unsigned int A_internal_cols,
          __global const float * B,  
          unsigned int B_row_start,
          unsigned int B_col_start,
          unsigned int B_row_size,
          unsigned int B_col_size,
          unsigned int B_internal_rows,
          unsigned int B_internal_cols,
          __global float * C,
          unsigned int C_row_start,
          unsigned int C_col_start,
          unsigned int C_row_size,
          unsigned int C_col_size,
          unsigned int C_internal_rows,
          unsigned int C_internal_cols,
          __local float * bufA,
          __local float * bufB) 
{ 
  size_t block_size = get_local_size(0);
  size_t row_block_id = get_group_id(0);
  size_t col_block_id = get_group_id(1);
  size_t row_thread_id = get_local_id(0);
  size_t col_thread_id = get_local_id(1);
  size_t row_block_id_ = get_local_id(1);
  size_t aBegin = (row_block_id * block_size + A_row_start) + A_col_start * A_internal_rows;
  size_t aStep = block_size * A_internal_rows;
  size_t bBegin = (col_block_id * block_size + B_row_start) + B_col_start * B_internal_rows;
  size_t bStep = block_size * B_internal_rows;
  size_t block_num = A_col_size / block_size;
  if (block_num * block_size != A_col_size)
    ++block_num;
  float Csub = 0;
  size_t aOffset = row_thread_id + col_thread_id * A_internal_rows;
  size_t bOffset = row_thread_id * B_internal_rows + col_thread_id;
  size_t row_thread_id_times_block_size = row_thread_id * block_size;
  for (size_t block = 0;
           block < block_num;
           ++block)
  {
    bufA[row_thread_id_times_block_size + col_thread_id] = (block * block_size + col_thread_id < A_col_size && get_global_id(0) < A_row_size) ? A[aBegin + aOffset] : 0;
    bufB[col_thread_id * block_size + row_thread_id] = ( (block * block_size + row_thread_id < B_col_size) && get_global_id(1) < B_row_size ) ? B[bBegin + bOffset] : 0;
    barrier(CLK_LOCAL_MEM_FENCE);
__local float * bufAptr = bufA + row_thread_id_times_block_size;
__local float * bufBptr = bufB + col_thread_id * block_size;
      Csub += (*bufAptr) * (*bufBptr); ++bufAptr; ++bufBptr;
      Csub += (*bufAptr) * (*bufBptr); ++bufAptr; ++bufBptr;
      Csub += (*bufAptr) * (*bufBptr); ++bufAptr; ++bufBptr;
      Csub += (*bufAptr) * (*bufBptr); ++bufAptr; ++bufBptr;
      Csub += (*bufAptr) * (*bufBptr); ++bufAptr; ++bufBptr;
      Csub += (*bufAptr) * (*bufBptr); ++bufAptr; ++bufBptr;
      Csub += (*bufAptr) * (*bufBptr); ++bufAptr; ++bufBptr;
      Csub += (*bufAptr) * (*bufBptr); ++bufAptr; ++bufBptr;
      Csub += (*bufAptr) * (*bufBptr); ++bufAptr; ++bufBptr;
      Csub += (*bufAptr) * (*bufBptr); ++bufAptr; ++bufBptr;
      Csub += (*bufAptr) * (*bufBptr); ++bufAptr; ++bufBptr;
      Csub += (*bufAptr) * (*bufBptr); ++bufAptr; ++bufBptr;
      Csub += (*bufAptr) * (*bufBptr); ++bufAptr; ++bufBptr;
      Csub += (*bufAptr) * (*bufBptr); ++bufAptr; ++bufBptr;
      Csub += (*bufAptr) * (*bufBptr); ++bufAptr; ++bufBptr;
    barrier(CLK_LOCAL_MEM_FENCE);
    aBegin += aStep;
    bBegin += bStep;
  }
  if (get_global_id(0) < A_row_size && get_global_id(1) < B_row_size)
    C[(get_global_id(0) + C_row_start) * C_internal_cols + get_global_id(1) + C_col_start] = Csub;
}