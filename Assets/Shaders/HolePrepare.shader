Shader "Test/HolePrepare" {
    SubShader {
        Tags { "RenderType"="Opaque" "Queue"="Geometry+1"}
        ColorMask 0    //开始玩花样了，这个球不渲染任何的颜色
        ZWrite off //关闭深度写，代表这个球是透明的
        //ZWrite on //效果好像没差别
        Stencil {
            Ref 1
            Comp always
            Pass replace
        }

        CGINCLUDE
            struct appdata {
                float4 vertex : POSITION;
            };
            struct v2f {
                float4 pos : SV_POSITION;
            };
            v2f vert(appdata v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }
            half4 frag(v2f i) : SV_Target {
                return half4(1,1,0,0.2);//ColorMask 0 的情况下，这里无用,不显示颜色的
            }
        ENDCG

        Pass {
            Cull Front
            ZTest Less
        
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            ENDCG
        }
        Pass {
            Cull Back
            ZTest Greater
        
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            ENDCG
        }
    } 
}