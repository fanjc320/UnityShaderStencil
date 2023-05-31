// jave.lin 2019.07.08
Shader "Test/Outline" {
    Properties {
        [KeywordEnum(P,NP)] _P("Perspective", Float) = 0
        _MainTex ("Texture", 2D) = "white" {}
        _OutlineWidth ("Outline width", Range(0, 0.1)) = 0.01
        _OutlineColor ("Outline color", Color) = (1,0,0,1)
    }
    SubShader {
        Tags { "RenderType"="Opaque" "Queue"="Geometry" }
        Stencil {
            ref 1
            comp always
            pass replace // mark-up
            zfail replace // mark-up
        }
        // draw model and write stencil
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            struct v2f {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };
            sampler2D _MainTex;
            float4 _MainTex_ST;
            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            fixed4 frag (v2f i) : SV_Target { return tex2D(_MainTex, i.uv); }
            ENDCG
        }
        // draw outline
        Pass {
            Stencil {
                ref 0
                comp equal
            }
            ZTest Always
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile _P_P _P_NP
            #include "UnityCG.cginc"
            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            half4 _OutlineColor;
            fixed _OutlineWidth;
            float4 vert (appdata v) : SV_POSITION {
                //// obj space，会有透视变化的问题，我们该用projection space下的pos.xy * posw消除透视，因为
                //v.vertex.xyz += v.normal * _OutlineWidth;
                //return UnityObjectToClipPos(v.vertex);

                // projection space
                float4 pos = UnityObjectToClipPos(v.vertex);
                fixed3 vNormal = mul((float3x3)UNITY_MATRIX_IT_MV, v.normal);
				fixed2 offset = TransformViewToProjection(vNormal.xy);
                //pos.xy += offset * _OutlineWidth * pos.w;
                #if _P_P // 有透视
                pos.xy += offset * _OutlineWidth;
                #else // 无透视
                // 因为在vertex post-processing会有perspective divide，所以我们先乘上pos.w以抵消透视
                // 这样无论多远多近都可以按恒定的描边边宽来显示
                pos.xy += offset * _OutlineWidth * pos.w;
                #endif
                return pos;
            }
            fixed4 frag () : SV_Target { return _OutlineColor; }
            ENDCG
        }
    }
}
