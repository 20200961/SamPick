package com.example.sampick.global.exception;

import jakarta.validation.ConstraintViolation;
import jakarta.validation.ConstraintViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;

//애플리케이션 전체의 controller에서 발생하는 예외를 처리하겠다.
@RestControllerAdvice
public class GlobalExceptionHandler {

    //@Vaild 검증 실패시
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleMethodArgumentNotValidException(MethodArgumentNotValidException ex) {

        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach((error) -> {
           String fieldName = ((FieldError)error).getField();
           String errorMsg = error.getDefaultMessage();
           errors.put(fieldName, errorMsg);
        });

        ErrorResponse response = ErrorResponse.of("입력값 검증에 실패하였습니다.", errors);
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }

    //@Vaildated 검증 실패 시 발생 (PathVariable, RequestParam)
    @ExceptionHandler(ConstraintViolationException.class)
    public ResponseEntity<ErrorResponse> handleConstraintViolationException(ConstraintViolationException ex) {
        Map<String, String> errors = ex.getConstraintViolations().stream()
                .collect(Collectors.toMap(
                        violation ->  violation.getPropertyPath().toString(),
                        ConstraintViolation::getMessage,
                        (existingValue, newValue) -> existingValue
                ));

        ErrorResponse response = ErrorResponse.of("입력값 검증에 실패하였습니다.", errors);
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }

    //나머지 모든 예외를 처리
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleException(Exception ex) {
        ErrorResponse response = ErrorResponse.of(ex.getMessage());
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
    }
}
