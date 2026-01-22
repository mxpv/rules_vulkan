RWBuffer<float> output : register(u0);

[numthreads(64, 1, 1)]
void CSMain(uint3 threadID : SV_DispatchThreadID) {
    output[threadID.x] = threadID.x * 2.0f;
}
