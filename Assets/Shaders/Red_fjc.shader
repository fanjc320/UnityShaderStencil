﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Red_fjc" {
    SubShader{
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry"}//这里渲染的类型为不透明物体，次序是Geometry。至于Geometry是多少我就不清楚的，求大神科普
        Pass {
            Stencil {
                Ref 2        //参考值为2，stencilBuffer值默认为0
                Comp always            //stencil比较方式是永远通过
                Pass replace           //pass的处理是替换，就是拿2替换buffer 的值
                ZFail decrWrap 		 //ZFail的处理是溢出型减1
            }
         				 //下面这段就不多说了，主要是stencil和Zbuffer都通过的话就执行。把点渲染成红色。
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
                return half4(1,0,0,1);
            }
            ENDCG
        }
    }
}