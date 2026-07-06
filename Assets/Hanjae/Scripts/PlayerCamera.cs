using UnityEngine;

public class PlayerCamera : MonoBehaviour
{
    [SerializeField] private float _rayDistance = 100f;
    [SerializeField] private LayerMask _rayMask = Physics.DefaultRaycastLayers;

    private Camera _camera;

    private void Awake()
    {
        _camera = GetComponent<Camera>();
        if (_camera == null)
            _camera = Camera.main;
    }

    public bool IsLookingAtActor()
    {
        return TryGetLookedActor(out _);
    }

    public bool TryGetLookedActor(out Actor actor)
    {
        actor = null;

        if (!TryRaycast(out RaycastHit hit))
            return false;

        Actor hitActor = hit.collider != null ? hit.collider.GetComponentInParent<Actor>() : null;
        if (hitActor == null)
            return false;

        if (!hitActor.CompareTag("Actor"))
            return false;

        actor = hitActor;
        return true;
    }

    private bool TryRaycast(out RaycastHit hit)
    {
        Camera cam = _camera != null ? _camera : Camera.main;
        if (cam == null)
        {
            hit = default;
            return false;
        }

        Ray ray = new Ray(cam.transform.position, cam.transform.forward);
        return Physics.Raycast(ray, out hit, _rayDistance, _rayMask, QueryTriggerInteraction.Ignore);
    }
}
