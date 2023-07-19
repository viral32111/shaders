using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Mesh : MonoBehaviour {
	public int xSize = 2;
	public int ySize = 2;

	private UnityEngine.Mesh cube;
	private Vector3[] vertices;

	void Start() {
		//cube = new UnityEngine.Mesh();
		//GetComponent<MeshFilter>().mesh = cube;

		cube = GetComponent<MeshFilter>().mesh;

		cube.Clear();

		cube.name = "Funny Cube";

		vertices = new Vector3[ ( xSize + 1 ) * ( ySize + 1 ) ];
		Vector2[] uv = new Vector2[ vertices.Length ];

		for ( int i = 0, y = 0; y <= ySize; y++ ) {
			for ( int x = 0; x <= xSize; x++, i++ ) {
				vertices[ i ] = new Vector3( x, y );
				uv[ i ] = new Vector2( ( float ) x / xSize, ( float ) y / ySize );
			}
		}

		cube.vertices = vertices;
		cube.uv = uv;

		int[] triangles = new int[ xSize * ySize * 6 ];

		for ( int ti = 0, vi = 0, y = 0; y < ySize; y++, vi++ ) {
			for ( int x = 0; x < xSize; x++, ti += 6, vi++ ) {
				triangles[ ti ] = vi;
				triangles[ ti + 1 ] = vi + xSize + 1;
				triangles[ ti + 2 ] = vi + 1;
				triangles[ ti + 3 ] = triangles[ ti + 2 ];
				triangles[ ti + 4 ] = triangles[ ti + 1 ];
				triangles[ ti + 5 ] = vi + xSize + 2;
			}
		}

		cube.triangles = triangles;

		cube.Optimize();
		cube.RecalculateNormals();
	}
}
