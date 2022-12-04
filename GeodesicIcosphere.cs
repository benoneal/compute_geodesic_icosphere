using UnityEngine;
using Unity.Collections;

public class GeodesicIcosphere {
  Compute Icosphere;
  
  ComputeBuffer verticesBuffer;
  ComputeBuffer neighboursBuffer;
  ComputeBuffer indicesBuffer;
  
  public ref ComputeBuffer vertices => ref verticesBuffer;
  public ref ComputeBuffer indices => ref indicesBuffer;
  public ref ComputeBuffer neighbours => ref neighboursBuffer;

  int max_resolution;
  int vertex_count;
  int index_count;
  
  public GeodesicIcosphere(int max_res = 256) {
    ComputeShader compute_shader = (ComputeShader)Resources.Load("Icosphere");
    Icosphere = new Compute(compute_shader);
    max_resolution = max_res;
    vertex_count = max_resolution * max_resolution * 10 + 2;
    index_count = max_resolution * max_resolution * 10 * 6 - 12;
    Init();
  }

  void Init() {
    Icosphere.SetKernel(0);
    Icosphere.SetBuffer("vertices", ref verticesBuffer, vertex_count, sizeof(float)*4);
    Icosphere.SetBuffer("neighbours", ref neighboursBuffer, vertex_count*6, sizeof(int));
    Icosphere.SetBuffer("indices", ref indicesBuffer, index_count, sizeof(int));
  }

  public int Create(int resolution) {
    int res = Mathf.Min(resolution, max_resolution);
    Icosphere.SetInt("resolution", res);
    Icosphere.Dispatch(1, res, res);
    return (res*res*10+2)*6-12;
  }

  public static int Footprint(int res) {
    int v_count = res * res * 10;
    int vertex_bytes = (v_count + 2) * sizeof(float)*4;
    int neighbour_bytes = (v_count + 2) * sizeof(int)*6;
    int index_bytes = (v_count * 6 - 12) * sizeof(int);
    return vertex_bytes + neighbour_bytes + index_bytes;
  }
}
