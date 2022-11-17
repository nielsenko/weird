#pragma once
#include <stdint.h>

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif

typedef struct {
  int64_t x;
  int64_t y;
} Point;

FFI_PLUGIN_EXPORT Point* createPoint(int64_t x, int64_t y);

FFI_PLUGIN_EXPORT void deletePoint(Point* point);

FFI_PLUGIN_EXPORT int64_t getPointCount();
