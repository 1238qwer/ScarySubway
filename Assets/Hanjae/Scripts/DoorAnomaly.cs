using UnityEngine;

public class DoorAnomaly : AnomalyBehaviour
{
    [SerializeField] private GameObject[] _doors;
    public override void Activate()
    {
        foreach (GameObject go in _doors)
        {
            if (go != null)
                go.SetActive(false);
        }
    }

    public override void Deactivate()
    {
        foreach (GameObject go in _doors)
        {
            if (go != null)
                go.SetActive(true);
        }
    }

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
