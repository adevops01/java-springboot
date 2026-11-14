package com.example.helloapi;

import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class TaskService {

    private final List<Task> tasks = new ArrayList<>();
    private int nextId = 1;

    // Constructor: adds 2 starter tasks when the app boots up
    public TaskService() {
        tasks.add(new Task(nextId++, "Learn Java basics", true));
        tasks.add(new Task(nextId++, "Build a Spring Boot API", false));
    }

    public List<Task> getAllTasks() {
        return tasks;
    }

    public Task addTask(String title) {
        Task newTask = new Task(nextId++, title, false);
        tasks.add(newTask);
        return newTask;
    }
}
