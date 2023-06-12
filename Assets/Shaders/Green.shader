Shader "Test/Green" {
    SubShader {
        Tags { "RenderType"="Opaque" "Queue"="Geometry+1"}
        Pass {
        //    Stencil {
        //        Ref 2
        //        Comp equal
        //        Pass keep 
        //        ZFail decrWrap // 会影响sphere_red 和 sphere_hold的遮挡关系
        ////模板测试是在深度测试（ZTest）之前的，没有通过模板测试的像素就会被舍弃不渲染，甚至直接跳过ZTest。
        //    }
        
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
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
                return half4(0,1,0,1);
            }
            ENDCG
        }
    } 
}