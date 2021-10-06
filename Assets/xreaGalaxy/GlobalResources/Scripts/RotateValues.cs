using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateValues : MonoBehaviour
{
    float x = 0;
    float y = 0;
    float z = 0;
    float baseVal = 0;
    public float speed = 10.0f;
    public float offsetX = 1.0f;
    public float offsetY = 1.0f;
    public float offsetZ = 1.0f;

    float xTrans = 0.0f;
    float yTrans = 0.0f;
    float zTrans = 0.0f;

    // Start is called before the first frame update
    void Start()
    {
        this.x = this.transform.rotation.x;
        this.y = this.transform.rotation.y;
        this.z = this.transform.rotation.z;
        Debug.Log(this.x);
        Debug.Log(this.y);
        Debug.Log(this.z);
    }

    
    // Update is called once per frame
    void Update()
    {
        baseVal = Mathf.Cos(Time.frameCount * speed) * 360;
        xTrans = this.x + (baseVal * offsetX);
        yTrans = this.y + (baseVal * offsetY);
        zTrans = this.z + (baseVal * offsetZ);
        this.transform.rotation = Quaternion.Euler(xTrans, yTrans, zTrans);
    }
}
