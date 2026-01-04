package com.example.sampick.global.common;

public class CommonEnums {

    public enum Status {
        Y, N;

        public static Status getDefault() {
            return Y;
        }
    }

    public enum Role {
        USER, ADMIN;
    }
}

