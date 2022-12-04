using UnityEngine;
using UnityEngine.Rendering;
using Unity.Collections;

[ExecuteAlways]
public class Icosphere : MonoBehaviour {
  public Material icosphereMaterial;

  GeodesicIcosphere sphere;

  ComputeBuffer argsBuffer;

  #if UNITY_EDITOR
  void OnDrawGizmos() {
    if (!Application.isPlaying) {
      UnityEditor.EditorApplication.QueuePlayerLoopUpdate();
      UnityEditor.SceneView.RepaintAll();
    }
  }
  #endif

  [Range(2,1028)]
  public int resolution = 3;
  [Range(2,1028)]
  public int max_resolution = 256;
  [Range(1,100f)]
  public float radius = 1f;
  [Range(0,1f)]
  public float equidistant = 0f;
  
  Bounds bounds;
  int verts;

  void Initialize() {
    sphere = new GeodesicIcosphere(max_resolution);
    bounds = new Bounds(transform.position, Vector3.one * radius);
    argsBuffer = new ComputeBuffer(4, sizeof(int));
  }

  void Render() {
    icosphereMaterial.SetFloat("radius", radius);
    icosphereMaterial.SetFloat("equidistant", equidistant);
    icosphereMaterial.SetBuffer("vertices", sphere.vertices);
    icosphereMaterial.SetBuffer("indices", sphere.indices);
    
    Graphics.DrawProcedural(
      icosphereMaterial,
      bounds,
      MeshTopology.Triangles, verts, 1,
      null, null,
      ShadowCastingMode.On, 
      true, gameObject.layer
    );

    // argsBuffer.SetData(new int[]{verts,1,0,0});
    // Graphics.DrawProceduralIndirect(
    //   icosphereMaterial,
    //   bounds,
    //   MeshTopology.Triangles, argsBuffer, 0,
    //   null, null,
    //   ShadowCastingMode.On, true, gameObject.layer
    // );
  }

  void Start() {
    Initialize();
    verts = sphere.Create(resolution);
  }

  void OnValidate() {
    resolution = Mathf.Min(resolution, max_resolution);
    Start();
  }

  void Update() {
    Render();
  }
}
