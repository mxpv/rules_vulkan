#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <vulkan/vulkan.h>

int main() {
    uint32_t version = 0;
    VkResult res = vkEnumerateInstanceVersion(&version);

    if (res == VK_SUCCESS) {
        printf("Vulkan version: %u.%u.%u\n",
            VK_VERSION_MAJOR(version),
            VK_VERSION_MINOR(version),
            VK_VERSION_PATCH(version));
    } else {
        printf("Failed to query Vulkan version (error %d)\n", res);
        return 1;
    }

    uint32_t layer_count = 0;
    vkEnumerateInstanceLayerProperties(&layer_count, NULL);

    VkLayerProperties* layers = malloc(layer_count * sizeof(VkLayerProperties));
    vkEnumerateInstanceLayerProperties(&layer_count, layers);

    printf("Available instance layers (%u):\n", layer_count);
    int has_validation = 0;
    for (uint32_t i = 0; i < layer_count; i++) {
        printf("  %s\n", layers[i].layerName);
        if (strcmp(layers[i].layerName, "VK_LAYER_KHRONOS_validation") == 0) {
            has_validation = 1;
        }
    }
    free(layers);

    if (!has_validation) {
        printf("ERROR: VK_LAYER_KHRONOS_validation not found\n");
        return 1;
    }

    // Portability enumeration is required on macOS where MoltenVK is a portability driver.
    VkInstanceCreateInfo create_info = {
        .sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
        .flags = VK_INSTANCE_CREATE_ENUMERATE_PORTABILITY_BIT_KHR,
        .enabledLayerCount = 1,
        .ppEnabledLayerNames = (const char*[]){
            "VK_LAYER_KHRONOS_validation",
        },
        .enabledExtensionCount = 1,
        .ppEnabledExtensionNames = (const char*[]){
            VK_KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME,
        },
    };

    VkInstance instance;
    res = vkCreateInstance(&create_info, NULL, &instance);
    if (res != VK_SUCCESS) {
        printf("Failed to create Vulkan instance (error %d)\n", res);
        return 1;
    }

    printf("Vulkan instance created OK\n");
    vkDestroyInstance(instance, NULL);
    return 0;
}
