using UnityEngine;

public abstract class AnomalyBehaviour : MonoBehaviour
{
    [SerializeField]
    private string anomalyID;

    public string ID => anomalyID;

    protected virtual void Awake()
    {
        AnomalyManager.Instance.Register(this);
    }

    public abstract void Activate();

    public virtual void Deactivate()
    {

    }
}