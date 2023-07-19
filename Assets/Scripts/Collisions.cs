using UnityEngine;

public class Collisions : MonoBehaviour {
    void OnCollisionEnter( Collision collision ) {
        Debug.Log( collision.gameObject + " started colliding with me!" );
    }

    void OnCollisionStay( Collision collision ) {
        Debug.Log( collision.gameObject + " is colliding with me!" );
    }

    void OnCollisionExit( Collision collision ) {
        Debug.Log( collision.gameObject + " stopped colliding with me!" );
    }
}
