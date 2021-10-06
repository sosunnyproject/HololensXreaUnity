using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateCan : MonoBehaviour
{
    float x = 0;
    float y = 0;
    float z = 0;
    float baseVal = 1.0f;
    public float speed = 0.1f;
    public float offsetX = 1.0f;
    public float offsetY = 1.0f;
    public float offsetZ = 1.0f;

    float xTrans = 0.0f;
    float yTrans = 0.0f;
    float zTrans = 0.0f;

    public float baseScale = 1.0f;
    public float sclOffset = 1.0f;
    float scaleChange = 1.0f;
    public float scaleTime = 0.1f;

    // Start is called before the first frame update
    void Start()
    {
        this.x = this.transform.rotation.x;
        this.y = this.transform.rotation.y - 90;
        this.z = this.transform.rotation.z;
    }


    // Update is called once per frame
    void Update()
    {
        baseVal = Mathf.Cos(Time.unscaledTime * speed) * 360;
        xTrans = this.x + (baseVal * offsetX);
        yTrans = this.y + (baseVal * offsetY);
        zTrans = this.z + (baseVal * offsetZ);

        scaleChange = baseScale + Mathf.Sin(Time.unscaledTime * scaleTime) * sclOffset;

        this.transform.rotation = Quaternion.Euler(xTrans, yTrans, zTrans);
        this.transform.localScale = new Vector3(scaleChange, scaleChange, scaleChange);
    }
}
