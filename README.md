# nixos-hypervisor
A WIP NixOS-based hypervisor solution

NixOS-hypervisor is my current solution for having a hypervisor running for my systems, leaving the host nixOS instance completely headless.

NixOS-hypervisor provides my ideal hypervisor solution with system-wide generation rollbacks for host based changes along with the immutability NixOS provides


# What is the point of this project?
I want a system that is somewhat xen-like without it actually being xen, mostly due to the fact that xen is difficult to near impossible to get GPU Passthrough working easily, this project makes my setup a xen-like and still be able to passthrough my GPU(s) easily
