#ifndef TRANSFORMS_INCLUDED
#define TRANSFORMS_INCLUDED

#include "Utils.hlsl"

int3 idToCoord(int3 id) {
  id.x = stlerp(id.x, id.x+10, id.y+1, id.z);
  id.y = stlerp(id.y, id.y-id.z, id.y+1, id.z);
  return id;
}

int3 coordToId(int3 coord) {
  coord.y = stlerp(coord.y, coord.y+coord.z, coord.x, 9);
  coord.x = stlerp(coord.x, coord.x-10, coord.x, 9);
  return coord;
}

int idToIndex(int3 id, int subdivisions) {
  return 2+id.x+id.y*ICO_SIDES+id.z*subdivisions*ICO_SIDES;
}

#endif 