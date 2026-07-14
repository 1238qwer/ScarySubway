using UnityEngine;

public abstract class AnomalyBehaviour : MonoBehaviour
{
    [SerializeField] private bool _activateWhenOutOfFrustum;
    [SerializeField, Range(0f, 1f)] private float _initialActiveChance = 0.5f;
    [SerializeField, Min(0f)] private float _selectionWeight = 1f;

    public string AnomalyID => gameObject.name;
    public bool ActivateWhenOutOfFrustum => _activateWhenOutOfFrustum;
    public float InitialActiveChance => _initialActiveChance;
    public float SelectionWeight => _selectionWeight;

    protected virtual void OnEnable()
    {
        AnomalyManager manager = AnomalyManager.Instance;
        if (manager == null)
            manager = Object.FindAnyObjectByType<AnomalyManager>();

        manager?.Register(this);
    }

    protected virtual void OnDisable()
    {
        AnomalyManager manager = AnomalyManager.Instance;
        if (manager == null)
            manager = Object.FindAnyObjectByType<AnomalyManager>();

        manager?.Unregister(this);
    }

    public abstract void Activate();
    public abstract void Deactivate();

    public virtual bool TryResolveWithActor(Actor actor)
    {
        return false;
    }

    public virtual bool IsInPlayerFrustum(Camera playerCamera)
    {
        if (playerCamera == null)
            return false;

        Renderer[] renderers = GetComponentsInChildren<Renderer>(true);
        if (renderers == null || renderers.Length == 0)
            return false;

        Plane[] planes = GeometryUtility.CalculateFrustumPlanes(playerCamera);

        for (int i = 0; i < renderers.Length; i++)
        {
            Renderer r = renderers[i];
            if (r == null || !r.enabled)
                continue;

            if (GeometryUtility.TestPlanesAABB(planes, r.bounds))
                return true;
        }

        return false;
    }
}