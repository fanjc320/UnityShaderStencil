Shader "Unlit/DoubleFace1"
{
    Properties{
        _MainTex("Main Texture", 2D) = "white"{}
        _SecTex("Second Texture", 2D) = "white" {}
        _DisplacementTex("Displacement Texture", 2D) = "white"{}
        _Magnitude("Magnitude", Range(0, 1)) = 0
    }
        SubShader
        {
            CGINCLUDE
            //声明类型
           sampler2D _MainTex;
           sampler2D _SecTex;
           sampler2D _DisplacementTex;
           float _Magnitude;
           //获取模型数据
           struct appdata
           {
               float4 vertex : POSITION;
               float2 uv: TEXCOORD0;
           };
           //存放计算结果
           struct v2f
           {
               float4 vertex : SV_POSITION;
               float2 uv: TEXCOORD1;
           };
           //数据给FS
           v2f vert(appdata v)
           {
               v2f o;
               o.vertex = UnityObjectToClipPos(v.vertex);
               o.uv = v.uv;
               return o;
           }
           ENDCG
               //渲染类型，适用于透明通道
               Tags { "RenderType" = "Transparent" }
               LOD 100
               Pass
               {
                   Blend SrcAlpha OneMinusSrcAlpha
                               Cull Back
                               ZWrite Off
                               CGPROGRAM
                               #pragma vertex vert
                               #pragma fragment frag
                               #include "UnityCG.cginc"
               // FS阶段
               fixed4 frag(v2f i) : SV_Target
               {

                      float2 disuv = float2(i.uv.x + _Time.x * 2, i.uv.y + _Time.x * 2);
                      fixed4 col = tex2D(_MainTex, i.uv);
                      float2 dis = tex2D(_DisplacementTex,disuv).xy;
                      dis = ((dis * 2) - 1) * _Magnitude;
                      //distortion
          float4 tex_color = tex2D(_MainTex, i.uv + dis);
                      return tex_color;
                 }
               //pass结束：没有报错
               ENDCG
    }

    pass
           {
                 Blend SrcAlpha OneMinusSrcAlpha
                 Cull Back
                 ZWrite Off
                 CGPROGRAM
                 #pragma vertex vert
                 #pragma fragment frag
                 #include "UnityCG.cginc"

                 float4 frag(v2f i) :SV_Target
                {
                     float4 color = tex2D(_SecTex,i.uv);
                     return color;
                 }
                 ENDCG
            }

        }
}