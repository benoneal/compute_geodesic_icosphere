#ifndef UTILS_INCLUDED
#define UTILS_INCLUDED

#define stlerp(a, b, c, d) lerp(b, a, step(c, d))

uint loop(uint i, uint n) {
  return (i%n+n)%n;
}

int loop(int i, int n) {
  return int(loop(uint(i), uint(n)));
}

float slerp(int start, int end, float t) {
  float d = clamp(dot(float(start), float(end)), -1.0, 1.0);
  float theta = acos(d)*t;
  float basis = end - start*d;
  return start*cos(theta) + basis*sin(theta);
}

float slerp(float start, float end, float t) {
  float d = clamp(dot(start, end), -1.0, 1.0);
  float theta = acos(d)*t;
  float basis = end - start*d;
  return start*cos(theta) + basis*sin(theta);
}

float3 slerp(float3 start, float3 end, float t) {
  float d = clamp(dot(start, end), -1.0, 1.0);
  float theta = acos(d)*t;
  float3 basis = normalize(end - start*d);
  return start*cos(theta) + basis*sin(theta);
}

float4 slerp(float4 start, float4 end, float t) {
  float d = clamp(dot(start, end), -1.0, 1.0);
  float theta = acos(d)*t;
  float4 basis = normalize(end - start*d);
  return start*cos(theta) + basis*sin(theta);
}

#endif // UTILS_INCLUDED
