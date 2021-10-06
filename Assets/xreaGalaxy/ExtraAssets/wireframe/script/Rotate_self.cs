using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate_self : MonoBehaviour
{
    float x = 0;

    float y = 0;
    float z = 0;

    // Start is called before the first frame update
    void Start()
    {
        this.x = this.transform.rotation.x;
        this.y = this.transform.rotation.y;
        this.z = this.transform.rotation.z;
    }

    float num = 0;
    // Update is called once per frame
    void Update()
    {
        num += Time.deltaTime * 20;
        if (num > 360)
            num = 0;
        this.transform.rotation = Quaternion.Euler(num, this.transform.rotation.y,  this.transform.rotation.z);
    }
}
