//一面正常，背面白色
Shader "Unlit/DoubleFace"
{
    Properties{
        _MainTex("Main Texture", 2D) = "white"{}
    }
        SubShader
    {
        CGINCLUDE
        //声明类型
       sampler2D _MainTex;
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
            ZWrite Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
        //FS阶段
        fixed4 frag(v2f i) : SV_Target
        {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG//pass结束：没有报错
        }

         pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Front
            ZWrite Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            float4 frag(v2f i) :SV_Target
            {
                float4 color = tex2D(_MainTex,i.uv);
                float alpha = color.a;
                float4 white = (1,1,1,1);
                color = lerp(white, color, 1 - alpha);
                return color;
            }
            ENDCG
        }

    }
}

//练习3：双Pass渲染，在平面前方渲染一张纹理，后方渲染同一张纹理，但将图片的非透明区域设为白色
//https://zhuanlan.zhihu.com/p/357921300