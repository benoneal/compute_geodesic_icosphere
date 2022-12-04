using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public struct Kernel {
  public int kernel;
  public uint x;
  public uint y;
  public uint z;
}

public class Compute {
  ComputeShader shader;
  public CommandBuffer command;

  private int kernel;

  public Compute(ComputeShader compute_shader) {
    shader = compute_shader;
    command = new CommandBuffer();
  }
  
  public void SetKernel(string name) {
    kernel = shader.FindKernel(name);
  }
  
  public void SetKernel(int k) {
    kernel = k;
  }

  public void SetBuffer(string name, ref ComputeBuffer buffer, int size, int stride, ComputeBufferType type = ComputeBufferType.Default) {
    if (buffer != null) {
      if (type == ComputeBufferType.Append) buffer.SetCounterValue(0);
      if (buffer.count == size && buffer.stride == stride) return;
      buffer.Release();
    }
    buffer = new ComputeBuffer(size, stride, type);
    #if UNITY_EDITOR
      UnityEditor.AssemblyReloadEvents.beforeAssemblyReload += buffer.Release;
    #endif
    
    SetBuffer(name, buffer);
  }

  public void SetBuffer(string name, ComputeBuffer buffer) {
    command.SetComputeBufferParam(shader, kernel, Shader.PropertyToID(name), buffer);
  }

  public void SetFloat(string param, float value) {
    command.SetComputeFloatParam(shader, Shader.PropertyToID(param), value);
  }
  public void SetInt(string param, int value) {
    command.SetComputeIntParam(shader, Shader.PropertyToID(param), value);
  }
  public void SetVector(string param, Vector4 value) {
    command.SetComputeVectorParam(shader, Shader.PropertyToID(param), value);
  }

  public void Dispatch(int x, int y, int z) {
    command.DispatchCompute(shader, kernel, x, y, z);
    Graphics.ExecuteCommandBuffer(command);
    command.Clear();
  }

  public void DispatchIndirect(ComputeBuffer args) {
    command.DispatchCompute(shader, kernel, args, 0);
    Graphics.ExecuteCommandBuffer(command);
    command.Clear();
  }

  public void Draw(Material mat, int verts) {
    // Still doesn't work for some reason. NFI
    command.DrawProcedural(Matrix4x4.identity, mat, 0, MeshTopology.Triangles, verts);
    Graphics.ExecuteCommandBuffer(command);
    command.Clear();
  }

  public void DrawIndirect(Material mat, ComputeBuffer args) {
    command.DrawProceduralIndirect(Matrix4x4.identity, mat, 0, MeshTopology.Triangles, args);
    Graphics.ExecuteCommandBuffer(command);
    command.Clear();
  }
}
