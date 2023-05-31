Shader "Test/Red" {
    SubShader {
        Tags { "RenderType"="Opaque" "Queue"="Geometry"}
        Pass {
            Stencil {
                Ref 2
                Comp always
                Pass replace
            }
        
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


//Stencil{
//Ref 2
//Comp equal
//Pass keep
//Fail decrWrap
//ZFail keep
//}
//下面一条一条来：
//Ref referenceValue，这个是设定参考值，stencilbuffer里面的值会与他比较
//ReadMask readMask，这个是在比较参考值和buffer值的时候用的，用于读取buffer值里面的值。
//WriteMask writeMask，这个是写入buffer值用的。
//
//Comp comparisonFunction，这个比较重要，这个是比较方式。大致有Greater，GEqual，Equal等八种比较方式，具体待会列图。
//
//Pass stencilOperation，这个是当stencil测试和深度测试都通过的时候，进行的stencilOperation操作方法。注意是都通过的时候！
//
//Fail stencilOperation，这个是在stencil测试通过的时候执行的stencilOperation方法。这里只要stencil测试通过就可以了
//
//ZFail stencilOperation，这个是在stencil测试通过，但是深度测试没有通过的时候执行的stencilOperation方法。
//
//
//
//一般Comp, Pass, Fail, ZFail只用于正面的渲染，除非有Cull front，这样的语句出现。如果要渲染两面，可以用CompFront，PassFront等和CompBack，PassBack等。意思和上面的一样
//————————————————
//版权声明：本文为CSDN博主「Vince197」的原创文章，遵循CC 4.0 BY - SA版权协议，转载请附上原文出处链接及本声明。
//原文链接：https ://blog.csdn.net/u013833399/article/details/47340447