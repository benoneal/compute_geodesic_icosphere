#ifndef ICOLOGIC_INCLUDED
#define ICOLOGIC_INCLUDED

#include "Constants.hlsl"
#include "Utils.hlsl"

struct IcoSide {
  float3 a;
  float3 b;
  float3 c;
  float3 n;
};

static const float3 ico_corners[12] = {
  normalize(float3(1, 1.61803398874989484820459, 0)),
  normalize(float3(0, 1, 1.61803398874989484820459)),
  normalize(float3(-1, 1.61803398874989484820459, 0)),
  normalize(float3(0, 1, -1.61803398874989484820459)),
  normalize(float3(1.61803398874989484820459, 0, -1)),
  normalize(float3(1.61803398874989484820459, 0, 1)),
  normalize(float3(-1.61803398874989484820459, 0, 1)),
  normalize(float3(-1.61803398874989484820459, 0, -1)),
  normalize(float3(0, -1, -1.61803398874989484820459)),
  normalize(float3(1, -1.61803398874989484820459, 0)),
  normalize(float3(0, -1, 1.61803398874989484820459)),
  normalize(float3(-1, -1.61803398874989484820459, 0))
};

static const int3 ico_faces[20] = {
  int3(0,2,1),
  int3(0,3,2),
  int3(0,4,3),
  int3(0,5,4),
  int3(0,1,5),

  int3(2,7,6),
  int3(3,8,7),
  int3(4,9,8),
  int3(5,10,9),
  int3(1,6,10),

  int3(1,2,6),
  int3(2,3,7),
  int3(3,4,8),
  int3(4,5,9),
  int3(5,1,10),

  int3(6,7,11),
  int3(7,8,11),
  int3(8,9,11),
  int3(9,10,11),
  int3(10,6,11)
};

static const int3 ico_adjacents[20] = {
  int3(4,1,10),
  int3(0,2,11),
  int3(1,3,12),
  int3(2,4,13),
  int3(3,0,14),

  int3(10,11,15),
  int3(11,12,16),
  int3(12,13,17),
  int3(13,14,18),
  int3(14,10,19),

  int3(9,5,0),
  int3(5,6,1),
  int3(6,7,2),
  int3(7,8,3),
  int3(8,9,4),

  int3(19,16,5),
  int3(15,17,6),
  int3(16,18,7),
  int3(17,19,8),
  int3(18,15,9),
};

static const int ico_adjacent_corners[10][5] = {
  {0,10,10,9,14},
  {1,11,11,5,10},
  {2,12,12,6,11},
  {3,13,13,7,12},
  {4,14,14,8,13},
  {5,15,15,19,10},
  {6,16,16,15,11},
  {7,17,17,16,12},
  {8,18,18,17,13},
  {9,19,19,18,14},
};

static const int ico_corner_stitches[20][5] = {
  {0,0,0,0,14},
  {0,0,0,0,10},
  {0,0,0,0,11},
  {0,0,0,0,12},
  {0,0,0,0,13},
  {0,0,0,0,19},
  {0,0,0,0,15},
  {0,0,0,0,16},
  {0,0,0,0,17},
  {0,0,0,0,18},
  {0,1,11,15,19}, // 10
  {0,2,12,16,15},
  {0,3,13,17,16},
  {0,4,14,18,17},
  {0,0,10,19,18}, // 14
  {0,11,16,0,5},
  {0,12,17,0,6},
  {0,13,18,0,7},
  {0,14,19,0,8},
  {0,10,15,0,9},
};

static const int3 _right_up[2] = {
  int3(0,0,2),
  int3(0,1,0),
};
static const int3 _right_up_edge[2] = {
  int3(4,7,2),
  int3(4,7,0),
};

static const int3 _down[2] = {
  int3(0,1,1),
  int3(0,0,1),
};
static const int3 _down_edge[2] = {
  int3(5,1,8),
  int3(5,0,8),
};

static const int3 _up[2] = {
  int3(0,0,2),
  int3(0,1,2),
};
static const int3 _up_edge[2] = {
  int3(5,2,6),
  int3(5,0,6),
};

static const int3 _left_up[2] = {
  int3(0,2,0),
  int3(0,2,2),
};
static const int3 _left_up_edge[2] = {
  int3(3,12,0),
  int3(3,13,2),
};

static const int3 _right_down[2] = {
  int3(0,1,0),
  int3(0,0,1),
};
static const int3 _right_down_edge[2] = {
  int3(4,7,0),
  int3(4,7,1),
};

static const int3 _left_down[2] = {
  int3(0,2,1),
  int3(0,2,0),
};
static const int3 _left_down_edge[2] = {
  int3(3,9,1),
  int3(3,11,0),
};

static const int3 _moves[2][6][2] = {
  { // faces
    _right_up,
    _down,
    _left_up,
    _up,
    _right_down,
    _left_down,
  },
  { // edges
    _right_up_edge,
    _down_edge,
    _left_up_edge,
    _up_edge,
    _right_down_edge,
    _left_down_edge,
  }
};

static const int3 _corner_moves[10] = {
  int3(14,0,6),
  int3(14,1,0),
  int3(14,0,1),
  int3(14,0,1),
  int3(14,6,0),

  int3(14,0,6),
  int3(14,1,0),
  int3(14,0,1),
  int3(14,6,0),
  int3(14,0,6),
};

static const int3 corner_stitches[3] = {
  int3(15,7,6), // connect to s_corner
  int3(15,7,8), // connect to nw_corner
  int3(15,6,8), // connect to ne_corner
};

int4 cardinalMove(int3 coord, int n, int c_max) {
  int i = n*0.5;
  int x = coord.x, y = coord.y, z = coord.z;
  int n_semisphere = x<5;
  int s_semisphere = x>14;
  int n_pole = n_semisphere && y == 0 && z == 1 && !n;
  int s_pole = s_semisphere && y == 0 && z == c_max && n == 3;
  int invert = x>9;
  int is_corner = invert && y == 0 && z == 0;

  int ne_edge = !invert && y == z-1;
  int s_edge = !invert && z == c_max;
  int nw_edge = !invert && y == 0;
  int n_edge = invert && z == 0;
  int se_edge = invert && y == c_max-z;
  int sw_edge = invert && y == 0;

  int edges[3] = {
    ne_edge || n_edge,
    s_edge || se_edge,
    nw_edge || sw_edge,
  };

  int inverted[3] = {
    invert,
    invert,
    (edges[2] && n_semisphere) || invert - (edges[2] && s_semisphere),
  };

  int3 move = stlerp(_moves[edges[i]][i+inverted[i]*3][uint(n)%2], _corner_moves[n+s_semisphere*5], is_corner, 0);

  int n_corner = nw_edge && ne_edge;
  int se_corner = s_edge && ne_edge;
  int sw_corner = s_edge && nw_edge;
  int s_corner = sw_edge && se_edge;
  int ne_corner = n_edge && se_edge;
  int nw_corner = n_edge && sw_edge;
  int stitches[6] = {
    0,
    (ne_corner)*1,
    (ne_corner)*2,
    s_corner*2,
    ((n_semisphere && sw_corner) || (!s_semisphere && s_corner))*3,
    0
  };
  // WTF this breaks everything???! 
  // move = stlerp(move, corner_stitches[stitches[n]-1], stitches[n], 0);

  if (stitches[n]) {
    move = corner_stitches[stitches[n]-1];
  }

  return int4(move, max(n_pole, s_pole*2));
}

int4 neighbourCoord(int3 coord, int n, int c_max) {
  int4 m = cardinalMove(coord, n, c_max);

  int3 adjacent = ico_adjacents[coord.x];
  int corner = ico_adjacent_corners[coord.x-10][n] - coord.x;
  int corner_stitch = ico_corner_stitches[coord.x][n] - coord.x;

  int xl = adjacent.x - coord.x;
  int xr = adjacent.y - coord.x;
  int xv = adjacent.z - coord.x;

  int moves[16] = {
    0, // 0
    1, // 1
    -1, // 2
    xl, // 3
    xr, // 4
    xv, // 5
    c_max, // 6
    -coord.y, // 7
    -coord.z, // 8
    coord.z, // 9
    coord.z+1, // 10
    coord.z-1, // 11
    c_max-coord.z, // 12
    c_max-coord.z+1, // 13
    corner, // 14
    corner_stitch, // 15
  };

  coord += int3(moves[m.x], moves[m.y], moves[m.z]);
  return int4(coord, m.w);
}

IcoSide createSide(int i) {
  int3 corners = ico_faces[i];
  IcoSide s;
  s.a = ico_corners[corners.x];
  s.b = ico_corners[corners.y];
  s.c = ico_corners[corners.z];
  s.n = normalize(s.a+s.b+s.c);
  return s;
}

int isCorner(int3 coord, int resolution) {
  return (loop(coord.y, resolution) + loop(coord.z, resolution)) == 0;
}

int neighbourCount(int3 coord, int resolution) {
  int corner = isCorner(coord, resolution);
  return 6 - corner;
}

float4 vertexPosition(int3 id, int resolution) {
  IcoSide side = createSide(id.x);
  float3 a = slerp(side.a, side.c, float(id.z)/resolution);
  float3 b = stlerp(
    slerp(side.a, side.b, float(id.z)/resolution),
    slerp(side.b, side.c, float(id.z)/resolution),
    id.x,
    9
  );
  int denom = stlerp(
    id.z,
    resolution-id.z,
    id.x,
    9
  );
  float3 pos = slerp(a, b, float(id.y)/denom);
  return float4(pos, neighbourCount(id, resolution));
}

#endif // ICOLOGIC_INCLUDED