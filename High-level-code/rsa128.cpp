// rsa128.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <chrono>

/**
 * @brief RSA encryption algorithm based on the Right-to-left binary method
 * C = m^e mod n
 * https://en.wikipedia.org/wiki/Modular_exponentiation#Right-to-left_binary_method
 */
auto encrypt(uint64_t base, uint64_t exponent, const uint64_t modulus)
{
    if (modulus == 1) return 0;
    auto result = 1;
    base %= modulus;
    while (exponent > 0) {
        if (exponent & 1) {
            result = (result * base) % modulus;
        }
        exponent >>= 1;
        base = (base * base) % modulus;
    }
    return result;
}


auto encrypt2(uint64_t base, uint64_t exponent, const uint64_t modulus)
{
    if (modulus == 1) return 0;

    // Own modulus operation by subtraction instead of %-operator
    const auto mod_op = [](auto value, const auto mod){
        while (value >= mod) 
            value -= mod;
        return value;
    };

    auto result = 1;
    base = mod_op(base, modulus);
    while (exponent > 0) {
        if (exponent & 1) {
            result = mod_op(result * base, modulus);
        }
        exponent >>= 1;
        base = mod_op(base * base, modulus);
    }
    return result;
}


int main()
{
    std::ios::sync_with_stdio(false);
    using namespace std::chrono;
    auto start = steady_clock::now();

    const auto m = 545;
    const auto e = 503;
    const auto mod = 943;

    //const auto encrypted_msg = encrypt(m, e, mod);
    const auto encrypted_msg = encrypt2(m, e, mod);

    auto end = steady_clock::now();
    std::cout << "\nExecution time: "
              << duration_cast<duration<float> >(end - start).count() << "s\n";

    std::cout << "Encrypted msg: " << encrypted_msg << '\n';
}