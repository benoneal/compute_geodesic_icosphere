#ifndef PROJECTIONS_INCLUDED
#define PROJECTIONS_INCLUDED

#define PI 3.14159265358979
#define up float3(0,1,0)

float3 planar(float3 p, float3 n) {
  return p - p*dot(p-n,n);
}

float3 project(float3 p, float3 n, float3 v) {
  return v-n*dot(v-p, n);
}

float4 project(float4 p, float4 n, float4 v) {
  return v-n*dot(v-p, n);
}

float radsBetween(float3 a, float3 b) {
  return acos(dot(a, b));
}

float degsBetween(float3 a, float3 b) {
  return degrees(radsBetween(a,b));
}

float3 rotate(float3 p, float3 axis, float angle) {
  return lerp(dot(axis, p)*axis, p, cos(angle)) + cross(axis,p)*sin(angle);
}

float4 rotate(float4 p, float3 axis, float angle) {
  return float4(rotate(p.xyz, axis, angle), p.w);
}

float3 equidistantProjection(float3 pos, float3 tilt = up, float radius = 1) {
  float3 tilt_axis = normalize(cross(tilt, up));
  if (radsBetween(tilt, up)) pos = rotate(pos, tilt_axis, radsBetween(tilt, up));
  float lat = asin(pos.y/radius);
  float lon = atan2(pos.x, -pos.z);
  return float3(lon, lat, 0)*radius;
}

float4 equidistantProjection(float4 pos, float3 tilt = up, float radius = 1) {
  return float4(equidistantProjection(pos.xyz, tilt, radius), 0);
}

float3 sphericalProjection(float2 long_lat, float3 tilt, float radius = 1) {
  float long = long_lat.x, lat = long_lat.y;
  float3 tilt_axis = normalize(cross(tilt, up));
  float3 pos = float3(cos(lat) * sin(long), sin(lat), -cos(lat) * cos(long));
  return rotate(pos, tilt_axis, -radsBetween(tilt, up))*radius;
}

float sphericalDistance(float3 a, float3 b) {
  return acos(saturate(dot(a, b)));
}

float sphericalDistance(float4 a, float4 b) {
  return acos(saturate(dot(a.xyz, b.xyz)));
}

float2 surfaceUV(float3 pos, float3 axis, int width, int height) {
  float2 dimensions = float2(width,height);
  float2 uv = equidistantProjection(pos, axis).xy*float2(1/(PI*2),1/PI)+0.5;
  return min(uv * dimensions, dimensions);
}

#endif 