using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShadersControl : MonoBehaviour {

    float timer = 0;
    float timerSciFi = 0;
    public float delayOffset = 2.0f;

    bool back = false;

	void Update () {
        if (timer <= -0.2f)
            back = false;
        if (timer > 1.2f)
            back = true;

        if (back == false)
        {
            timer += Time.deltaTime / delayOffset;
        }
        if (back)
        {
            timer -= Time.deltaTime / delayOffset;
        }
        
        Shader.SetGlobalFloat("_ShaderDisplacement", timer);
        Shader.SetGlobalFloat("_ShaderHologramDisplacement", 1 - timer);
        Shader.SetGlobalFloat("_ShaderDissolve", 1 - timer);

        if (timerSciFi > 1.2f)
            timerSciFi = 0;

        timerSciFi += Time.deltaTime / (delayOffset + 1);

        Shader.SetGlobalFloat("_ShaderSciFi", timerSciFi);
        
    }
}
