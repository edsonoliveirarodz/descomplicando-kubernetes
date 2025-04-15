from locust import HttpUser, task

class StressTest(HttpUser):
    @task
    def stress_test(self):
        self.client.get("/")