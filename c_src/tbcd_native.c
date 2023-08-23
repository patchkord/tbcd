#include "erl_nif.h"

// https://mattpo.pe/posts/tips-and-tricks-nifs/

const char* tbcd_to_ascii = "0123456789*#abc";

const char ascii_to_tbcd[] = {
  15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, /* filler when there is an odd number of digits */
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0,11, 0, 0, 0, 0, 0, 0,10, 0, 0, 0, 0, 0, /* # * */
  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 0, 0, 0, 0, 0, /* digits */
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0,12,13,14            /* a b c */
};

static ERL_NIF_TERM
mk_atom(ErlNifEnv* env, const char* atom)
{
  ERL_NIF_TERM ret;

  if (!enif_make_existing_atom(env, atom, &ret, ERL_NIF_LATIN1)) {
    return enif_make_atom(env, atom);
  }

  return ret;
}

static ERL_NIF_TERM
mk_error(ErlNifEnv* env, const char* mesg)
{
    return enif_make_tuple2(env, mk_atom(env, "error"), mk_atom(env, mesg));
}

/* Convert the TBCD to ASCII */
static ERL_NIF_TERM
decode(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
  char ascii[64] = { 0 };

  // Check that the arity of the function is correct.
  if (argc != 1) {
    return enif_make_badarg(env);
  }

  ErlNifBinary bin;
  if (!enif_inspect_binary(env, argv[0], &bin)) {
    return mk_atom(env, "not_binary");
  }

  if (bin.size * 2 >  sizeof(ascii)) {
    return mk_atom(env, "binary_to_long");
  }

  for (size_t i = 0; i < bin.size; i++) {
    size_t pos = bin.size - i - 1; /* reversed position */
    ascii[2 * i] = tbcd_to_ascii[bin.data[pos] & 0x0f];
    ascii[2 * i + 1] = tbcd_to_ascii[(bin.data[pos] & 0xf0) >> 4];
  }

  return enif_make_string(env, ascii, ERL_NIF_LATIN1); // TODO: restrict len
}

/* Convert the ASCII to TBCD */
static ERL_NIF_TERM
encode(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
  ERL_NIF_TERM list = argv[0];
  ERL_NIF_TERM is_list = argv[0];
  unsigned list_length;

  // Check that the arity of the function is correct.
  if (argc != 1) {
    return enif_make_badarg(env);
  }

  // First check if we are infact a list.
  if (!enif_is_list(env, is_list)) {
    return enif_make_badarg(env);
  }

  // Get the length of the list.
  if (!enif_get_list_length(env, list, &list_length)) {
    return mk_error(env, "get_list_length");
  }

  int size = (list_length + 1) / 2;

  ErlNifBinary bin;
  if (!enif_alloc_binary(size, &bin)) {
    return mk_error(env, "nif_alloc_binary");
  }

  ERL_NIF_TERM head;
  ErlNifUInt64 current = 0;
  for (size_t i = 0; enif_get_list_cell(env, list, &head, (ERL_NIF_TERM*) &list); i++) {
    if (!enif_get_uint64(env, head, &current)) {
      return mk_error(env, "list_element_not_uint64");
    }

    size_t pos = bin.size - (i / 2) - 1; /* reversed position */

    if (i % 2)
      bin.data[pos] = (ascii_to_tbcd[current] << 4) | (bin.data[pos] & 0x0f);
    else
      bin.data[pos] = (0xf0 | ascii_to_tbcd[current]);
  }

  return enif_make_binary(env, &bin);
}

static ErlNifFunc nif_funcs[] = {
  {"encode", 1, encode},
  {"decode", 1, decode}
};

ERL_NIF_INIT(tbcd_native, nif_funcs, NULL, NULL, NULL, NULL);
