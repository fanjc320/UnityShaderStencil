// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/CreateCircle1"
{
	Properties
	{
		_BgColor("Background Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
	}
		SubShader{

		//Tags {"Queue" = "Background"}
		Tags {"Queue" = "Geometry-1"}//同上，遮挡关系正确，但是无色的部分不是想要的圆形,原型以外的应该是透明才对.
		//说明先渲染加 colormask 0 是无色清空效果,清空被遮挡的，即z更大的，说明渲染顺序是按z比较大的先渲染，虽然本shader的渲染队列更优先
		Tags {"Queue" = "Geometry+1"}//完全透明，看不到
		Blend SrcAlpha OneMinusSrcAlpha

		//Tags { "RenderType" = "Opaque"} //fjc

		//Lighting Off
		/*ZWrite On
		ZTest Always*/

		Pass
		{
			//Color(0,0,0,0) //先清空framebuffer?
			//ColorMask 0
		}

		Pass
		{
		//Blend SrcAlpha OneMinusSrcAlpha
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag Lambert alpha
		// make fog work
		#pragma multi_compile_fog
		#include "UnityCG.cginc"
		sampler2D _MainTex;
		fixed4 _BgColor;
		struct appdata
		{
			float4 vertex : POSITION;
			float2 uv : TEXCOORD0;
		};
		struct v2f
		{
			float2 uv : TEXCOORD0;
			UNITY_FOG_COORDS(1)
			float4 vertex : SV_POSITION;
		};
		float4 _MainTex_ST;
		v2f vert(appdata v)
		{
			v2f o;
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.uv = TRANSFORM_TEX(v.uv, _MainTex);
			UNITY_TRANSFER_FOG(o,o.vertex);
			return o;
		}

		fixed4 frag(v2f i) : SV_Target
		{
			fixed4 c = tex2D(_MainTex,i.uv);
			float x = i.uv.x;
			float y = i.uv.y;
			float dis = sqrt(pow((0.5 - x), 2) + pow((0.5 - y), 2));
			//if (dis > 0.5) {
			if (dis < 0.5) {
				discard; // 如果没有上面个的pass ColorMask 0, 就没有遮挡
				//return; //不对，没有返回颜色值
				//return fixed4(0, 0, 0, 0);//注释掉Blend SrcAlpha OneMinusSrcAlpha就是纯黑色，否则无色; 加了上面的pass之后透明
			}
			else {
				//return fixed4(0,0,0,0); //可能还是清空效果
			}
			return c;
			}
		ENDCG
		}
		}
}