/// <class>CrumbleTransitionEffect</class>

/// <description>A transition effect </description>
/// <summary>The amount(%) of the transition from first texture to the second texture. </summary>

/// <minValue>0</minValue>
/// <maxValue>100</maxValue>
/// <defaultValue>30</defaultValue>
float Progress : register(C0);

/// <minValue>-1</minValue>
/// <maxValue>1</maxValue>
/// <defaultValue>0</defaultValue>
float randomSeed : register(C1);
sampler2D Texture1 : register(s0);
sampler2D Texture2 : register(s1);

// default texturemap for this effect is Clouds
sampler2D TextureMap : register(s2);

struct VS_OUTPUT
{
    float4 Position  : POSITION;
    float4 Color     : COlOR;
    float2 UV        : TEXCOORD;
};

float4 Crumple(float2 uv, float progress)
{
  float2 offset = tex2D(TextureMap, float2(uv.x / 5, frac(uv.y / 5 + min(0.9, randomSeed)))).xy * 2.0 - 1.0;
  float p = progress * 2;
  if (p > 1.0)
  {
    p = 1.0 - (p - 1.0);
  }
  float4 c1 = tex2D(Texture2, frac(uv + offset * p));
  float4 c2 = tex2D(Texture1, frac(uv + offset * p));

  return lerp(c1, c2, progress);
}

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 main(VS_OUTPUT input) : COlOR
{
  return Crumple(input.UV, Progress/100);
}
