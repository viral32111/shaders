Shader "Unlit/Spinner" {
	// Properties that show in the inspector
	Properties{
		_MainTex( "Texture", 2D ) = "white" {}
		Speed( "Speed", Float ) = 1
		Height( "Height", Float ) = 0.5
	}

	// The actual shader
	SubShader {
		// Set the type tags for this shader
		Tags {
			"RenderType" = "Opaque"
		}

		LOD 100

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
			float Speed;
			float Height;

			// start with vertex-2-frag, which is returned then passed into the fragment function
			// vertex shader changes model data (shape)
			v2f vert( appdata v ) {
				v2f o;

				// apply a rotation
				float alpha = ( _Time.y * Speed ) * UNITY_PI / 180.0;
				float sinValue, cosValue;
				sincos( alpha, sinValue, cosValue );
				float2x2 rotateMatrix = float2x2( cosValue, -sinValue, sinValue, cosValue );
				v.vertex = float4( mul( rotateMatrix, v.vertex.xz ), v.vertex.yw ).xzyw;

				// apply a upy and downy thingy
				v.vertex.y += cos( _Time.y ) * Height;

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

				// Return the changes made
				return col;
			}

			// End the CG code
			ENDCG
		}
	}
}
