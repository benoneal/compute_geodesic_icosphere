Shader "Procedural/Icosphere" {
  SubShader {
		Tags { "RenderType"="Opaque" "LightMode"="ForwardBase" }
    Cull back
    ZWrite On
    // LOD 200

		Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
      #pragma target 4.5
      #pragma multi_compile_fwdbase
      
			#include "UnityCG.cginc"
      #include "AutoLight.cginc"
			#include "Projections.hlsl" 

      struct v2f {
        float4 vertex: SV_POSITION;
        float4 mesh: TEXCOORD0;
        float4 world: TEXCOORD1;
        uint id: TEXCOORD2;
      };
      
      StructuredBuffer<float4> vertices;
      StructuredBuffer<int> indices;

      float radius;
      float equidistant;
      
      void vert (uint id : SV_VertexID, inout v2f o) {
        float3 vert = vertices[indices[id]].xyz;
        o.mesh = float4(vert, 1);
        o.world = float4(lerp(rotate(vert, float3(0,1,0), _Time.y)*(1+sin(vert.y*15+_Time.y)*0.05), equidistantProjection(vert), equidistant)*radius, 1);
        o.vertex = UnityObjectToClipPos(o.world);
        o.id = id;
      }

      float4 frag (v2f i) : SV_TARGET {
        return i.mesh*0.5+0.5;
      }
      ENDCG
    }
    // Pass to render object as a shadow caster
    Pass {
      Name "ShadowCaster"
      Tags { "LightMode" = "ShadowCaster" }
      
      ZWrite On ZTest LEqual Cull Off

      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
      #pragma target 4.5
      #pragma multi_compile_shadowcaster

      #include "UnityCG.cginc"
			#include "Projections.hlsl" 

      struct v2f {
        V2F_SHADOW_CASTER;
      };
      
      StructuredBuffer<float4> vertices;
      StructuredBuffer<int> indices;

      float radius;
      float equidistant;

      void vert(uint id : SV_VertexID, inout v2f o, appdata_base v) {
        float3 vert = vertices[indices[id]].xyz;
        float4 pos = float4(lerp(vert, equidistantProjection(vert), equidistant)*radius, 1);
        v.vertex = pos;
        o.pos = UnityObjectToClipPos(pos);
      }

      float4 frag(v2f i) : COLOR {
        return 0;
      }
      ENDCG
    }
  }
	Fallback "Diffuse"
}
