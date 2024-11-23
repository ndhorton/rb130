#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdint.h>

typedef struct vector
{
        int64_t *list;
        int size;
        int all;
} vector;

vector *new_vector()
{
        vector *vec = malloc(sizeof(vector));
        if (vec == NULL) {
                exit(1);
        }
        vec->list = malloc(sizeof(int64_t) * 40 );
        if (vec->list == NULL) {
                exit(1);
        }
        vec->size = 0;
        vec->all = 40;
        return vec;
}

void ralloc_vector(vector *v)
{
        int64_t *new_list = malloc(sizeof(int64_t) * (v->all * 2));
        if (new_list == NULL) {
                exit(1);
        }
        int64_t *olp = v->list;
        int64_t *nlp = new_list;
        for (int i = 0; i < v->size; i++) {
                *nlp = *olp;
                nlp++;
                olp++;
        }
        free(v->list);
        v->list = new_list;
}

void vector_push(vector *v, int64_t value)
{
        if (v->all - v->size < v->all / 2) {
                ralloc_vector(v);
        }
        v->list[v->size] = value;
        v->size += 1;
}

void delete_vector(vector *v)
{
        free(v->list);
        free(v);
}

void vector_print(vector *v)
{
        printf("{ ");
        for (int i = 0; i < v->size; i++) {
                printf("%d ", v->list[i]);
        }
        printf("}\n");
}

bool isPrime(int64_t x)
{
        if ((x > 2 && x % 2 == 0) || x < 2) {
                return false;
        }

        for (int64_t i = 3; i * i <= x; i += 2) {
                if (x % i == 0)
                        return false;
        }
        return true;
}

int64_t first_prime_divisor(int64_t x)
{
        for (int64_t i = 3; i < x; i += 2) {
                if (x % i == 0 && isPrime(i)) {
                        return i;
                }
        }
        return -1;
}

vector *euclidean_primes(int n)
{
        vector *result = new_vector();
        vector_push(result, 2);
        vector_push(result, 3);
        for (int i = 3; i <= n; i++) {
                int64_t qa = 1;
                for (int j = 0; j < result->size; j++) {
                        qa *= result->list[j];
                }
                qa++;

                int64_t prime = qa;
                if (!isPrime(qa)) {
                        prime = first_prime_divisor(qa);
                }
                vector_push(result, prime);
        }
        return result;
}

int main(void)
{
        vector *v = euclidean_primes(15);
        vector_print(v);
        delete_vector(v);
        // printf("%d\n", first_prime_divisor(6221671));
}