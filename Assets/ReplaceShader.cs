using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ReplaceShader : MonoBehaviour
{
    public Shader _shader;//引用的Shader
    public Texture _MainColor;//替换的贴图1

    public Texture _SecColor;//替换的贴图2


    // Start is called before the first frame update
    private void OnEnable()
    {
        if (_shader != null)
        {
            GetComponent<Camera>().SetReplacementShader(_shader, "RenderType");//根据渲染类型把场景不同类型的RenderType替换到对应的Shader
            Shader.SetGlobalTexture("_MainTexture", _MainColor);//把贴图替换掉
            Shader.SetGlobalTexture("_SecTexture", _SecColor);
        }
    }
    private void OnDisable()
    {
        GetComponent<Camera>().ResetReplacementShader();
    }

    private void OnValidate()
    {
    }
}