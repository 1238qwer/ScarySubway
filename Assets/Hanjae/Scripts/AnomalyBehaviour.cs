using UnityEngine;

public abstract class AnomalyBehaviour : MonoBehaviour
{
    [SerializeField] private string anomalyID;
    public string ID => anomalyID;

    private AnomalyManager _manager;

    protected virtual void OnEnable()
    {
        _manager = Object.FindAnyObjectByType<AnomalyManager>();
        _manager?.Register(this);
    }

    protected virtual void OnDisable()
    {
        _manager?.Unregister(this);
    }

    public abstract void Activate();

    public abstract void Deactivate();


    public virtual bool TryResolveWithActor(Actor actor)
    {
        return false;
    }
}