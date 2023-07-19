Shader "Unlit/Shadertoy" {
	Properties {
		_MainTex ( "Texture", 2D ) = "white" {}
	}

	SubShader {
		Tags {
			"RenderType" = "Opaque"
		}

		LOD 100

		Pass {
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			//#define mod(x, y) x-y*floor(x/y)

			struct appdata {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert( appdata v ) {
				v2f o;
				o.vertex = UnityObjectToClipPos( v.vertex );
				o.uv = TRANSFORM_TEX( v.uv, _MainTex );
				return o;
			}

			/* https://www.shadertoy.com/view/XsjGDt */

			float3 rgb( float r, float g, float b ) {
				return float3( r / 255.0, g / 255.0, b / 255.0 );
			}

			float4 circle( float2 uv, float2 pos, float rad, float3 color ) {
				float d = length( pos - uv ) - rad;
				float t = clamp( d, 0.0, 1.0 );
				return float4( color, 1.0 - t );
			}

			float4 mainImage( v2f i ) {
				float2 uv = i.uv.xy;
				float2 center = i.uv.xy * 0.5;
				float radius = 0.25 * i.uv.y;

				float4 backgroundLayer = float4( rgb( 210.0, 222.0, 228.0 ), 1.0 );
				float4 circleLayer = circle( uv, center, radius, rgb( 225.0, 95.0, 60.0 ) );

				return lerp( backgroundLayer, circleLayer, circleLayer.a );
			}

			fixed4 frag( v2f i ) : SV_Target {
				return mainImage( i );
			}

			ENDCG
		}
	}
}
