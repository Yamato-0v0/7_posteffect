Shader "Unlit/B NewUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Raduis("Radius",Range(0,100)) = 5.0
    }
    SubShader
    {
        Cull off Zwrite Off Ztest Always
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #include "UnityCustomRenderTexture.cginc"

            #pragma vertex CustomRenderTextureVertexShader
            #pragma fragment frag

            sampler2D _MainTex;
            float4 _MainTex_TexelSize;
            float _Radius;

            fixed4 frag(v2f_customrendertexture i) : SV_Target
            {
                // sample the texture
                float2 scale = _MainTex_TexelSize.xy * _Radius;
                fixed4 col = fixed4(0, 0, 0, 1);
                col += tex2D(_MainTex, i.globalTexcoord + float2(-1, 0) * scale);
                col += tex2D(_MainTex, i.globalTexcoord + float2(+1, 0) * scale);
                col += tex2D(_MainTex, i.globalTexcoord + float2(0, -1) * scale);
                col += tex2D(_MainTex, i.globalTexcoord + float2(0, +1) * scale);

                col += tex2D(_MainTex, i.globalTexcoord + float2(-0.707, -0.707) * scale);
                col += tex2D(_MainTex, i.globalTexcoord + float2(+0.707, -0.707) * scale);
                col += tex2D(_MainTex, i.globalTexcoord + float2(-0.707, +0.707) * scale);
                col += tex2D(_MainTex, i.globalTexcoord + float2(+0.707, +0.707) * scale);
                col /= 8;
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
