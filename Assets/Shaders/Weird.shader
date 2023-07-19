Shader "Unlit/Unlit" {
	// Properties that show in the inspector
	Properties{
		_MainTex( "Base Texture", 2D ) = "white" {}
		TintColor( "Tint Color", Color ) = ( 1, 1, 1, 1 )
		Transparency( "Transparency", Range( 0.0, 1 ) ) = 0.25

		Distance( "Distance", Float ) = 1
		Amplitude( "Amplitude", Float ) = 1
		Speed( "Speed", Float ) = 1
		Amount( "Amount", Float ) = 1
	}

	// The actual shader
	SubShader {
		// Set the type tags for this shader
		Tags {
			"Queue" = "Transparent"
			"RenderType" = "Transparent"
		}

		LOD 100

		ZWrite Off // Do not render to the depth buffer
		Blend SrcAlpha OneMinusSrcAlpha // Render in order, then blend together using alpha channel (stage is multiplied by 1)

		Pass {
			// Begin CG code
			CGPROGRAM

			// Define what our vertex and fragment functions are
			#pragma vertex vert
			#pragma fragment frag

			// Add Unity helper functions
			#include "UnityCG.cginc"

			// Model data
			struct appdata {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			// For passing out of vertex function into fragment function
			struct v2f {
				float4 vertex : SV_POSITION; // Screen Space Position
				float2 uv : TEXCOORD0;
			};

			// Global variables from the properties at the top of the file
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 TintColor;
			float Transparency;

			float Distance;
			float Amplitude;
			float Speed;
			float Amount;

			// start with vertex-2-frag, which is returned then passed into the fragment function
			// vertex shader changes model data (shape)
			v2f vert( appdata v ) {
				v2f o;

				// _Time.y is the current time in seconds
				v.vertex.x += sin( _Time.y * Speed + v.vertex.y * Amplitude ) / Distance * Amount;
				//v.vertex.y += cos( _Time.y ) * 0.3;
				// v.vertex.z += tan( _Time.y ) * 0.1;

				// Clamp to bounds of the base gameobject
				o.vertex = UnityObjectToClipPos( v.vertex ); // Helper function provided by Unity
				o.uv = TRANSFORM_TEX( v.uv, _MainTex );

				// Return the changes made, which will be passed to the fragment shader
				return o;
			}

			// starts with the returned vertex-2-frag from the vertex function
			// fragment shader changes colors and alpha (apperance)
			fixed4 frag( v2f i ) : SV_Target { // SV_Target is a render target (framebuffer for the screen)
				// sample the texture
				fixed4 col = tex2D( _MainTex, i.uv ); // color (rgba)

				// color tint
				col += TintColor;

				// set alpha of color
				col.a = Transparency;

				// Return the changes made
				return col;
			}

			// End the CG code
			ENDCG
		}
	}
}
