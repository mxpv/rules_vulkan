#include <stdio.h>
#include <volk/volk.h>

int main() {
    VkResult res = volkInitialize();
    if (res != VK_SUCCESS) {
        printf("Failed to initialize Volk (error %d)\n", res);
        return 1;
    }

    uint32_t version = volkGetInstanceVersion();
    printf("Vulkan version (via Volk): %u.%u.%u\n",
        VK_VERSION_MAJOR(version),
        VK_VERSION_MINOR(version),
        VK_VERSION_PATCH(version));

    return 0;
}
