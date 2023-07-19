using UnityEngine;

public class Lerp : MonoBehaviour {
	public GameObject destinationCube;
	public float smoothing = 1.0f;
	public float distance = 0.1f;

	private Vector3 startingPosition = Vector3.zero;
	private Quaternion startingRotation = new Quaternion( 0, 0, 0, 0 );

	void Start() {
		startingPosition = transform.position;
		startingRotation = transform.rotation;
	}

    void Update() {
		gameObject.transform.position = Vector3.Lerp( gameObject.transform.position, destinationCube.transform.position, Time.deltaTime * smoothing );
		gameObject.transform.rotation = Quaternion.Lerp( gameObject.transform.rotation, destinationCube.transform.rotation, Time.deltaTime * smoothing );

		if ( gameObject.transform.position.x >= ( destinationCube.transform.position.x - distance ) ) {
			gameObject.transform.position = startingPosition;
			gameObject.transform.rotation = startingRotation;
		}
	}
}
