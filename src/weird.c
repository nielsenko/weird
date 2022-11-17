#include "weird.h"
#include <stdlib.h>

int64_t count = 0;

FFI_PLUGIN_EXPORT Point *createPoint(int64_t x, int64_t y)
{
  Point *p = malloc(sizeof(Point));
  p->x = x;
  p->y = y;
  count++;
  return p;
}

FFI_PLUGIN_EXPORT void deletePoint(Point *point)
{
  --count;
  free(point);
};

FFI_PLUGIN_EXPORT int64_t getPointCount() {
  return count;
}
