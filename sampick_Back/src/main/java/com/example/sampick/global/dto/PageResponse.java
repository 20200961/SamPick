package com.example.sampick.global.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import org.springframework.data.domain.Page;

import java.util.List;

@Getter
public class PageResponse<T> {

    @JsonProperty("content")
    private final List<T> content;

    @JsonProperty("total_count")
    private final long totalCount;

    @JsonProperty("current_page")
    private final int currentPage;

    @JsonProperty("page_size")
    private final int pageSize;

    @JsonProperty("has_next")
    private final boolean hasNext;

    @JsonProperty("has_prev")
    private final boolean hasPrev;

    public PageResponse(Page<T> page) {
        this.content = page.getContent();
        this.totalCount = page.getTotalElements();
        this.currentPage = page.getNumber();
        this.pageSize = page.getTotalPages();
        this.hasNext = page.hasNext();
        this.hasPrev = page.hasPrevious();
    }
}

