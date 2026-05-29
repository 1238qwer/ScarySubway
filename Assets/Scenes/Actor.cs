using UnityEngine;

public class Actor : MonoBehaviour
{
    private ActorManager _actorManager;
    private GameObject _head;

    float rottime;
    float jumpTime;

    bool isRotate;
    bool isJumpSquere;

    Vector3 oriPos;
    Quaternion oriRot;

    Vector3 jumpLocalPos;

    [SerializeField] private float shakeAmount = 0.03f;
    [SerializeField] private float shakeSpeed = 80f;

    void Start()
    {
        _actorManager = GetComponentInParent<ActorManager>();

        _head = transform.Find("Capsule")
            .transform.Find("Head")
            .gameObject;

        oriPos = gameObject.transform.position;
        oriRot = gameObject.transform.rotation;
    }

    void Update()
    {
        if (isRotate)
        {
            rottime += Time.deltaTime;

            if (rottime > 3f)
            {
                isRotate = false;

                _head.transform.localRotation =
                    Quaternion.identity;

                rottime = 0;
            }
        }

        if (isJumpSquere)
        {
            jumpTime += Time.deltaTime;

            float x =
                Mathf.Sin(Time.time * shakeSpeed)
                * shakeAmount;

            float y =
                Mathf.Cos(Time.time * shakeSpeed * 1.3f)
                * shakeAmount;

            transform.localPosition =
                jumpLocalPos +
                new Vector3(x, y, 0);

            if (jumpTime > 0.7f)
            {
                isJumpSquere = false;

                transform.parent =
                    _actorManager.gameObject.transform;

                gameObject.transform.position = oriPos;
                gameObject.transform.rotation = oriRot;

                jumpTime = 0;
            }
        }
    }

    public void NeckRotateToPlayer()
    {
        _head.transform.LookAt(
            Camera.main.transform.position
        );

        isRotate = true;
    }

    internal void JumpSquare(Transform pos)
    {
        gameObject.transform.parent = pos;

        jumpLocalPos = Vector3.zero;

        gameObject.transform.localPosition =
            jumpLocalPos;

        gameObject.transform.localRotation =
            Quaternion.identity;

        isJumpSquere = true;
    }
}