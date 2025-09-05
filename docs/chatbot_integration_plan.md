# Chatbot Integration Plan

## 1. Objective

To integrate an intelligent chatbot into the existing 3D homepage. The chatbot will act as a conversational guide, providing contextual information and triggering interactive events within the 3D scene based on user input.

## 2. Codebase Integration Strategy

Our primary goal is to avoid disrupting the current frontend. The integration will be handled as follows:

*   **Chat UI Overlay**: A new set of HTML elements (`<div>`) will be added to `index.html`. These elements will be styled using CSS to float above the Three.js canvas, likely in a fixed corner of the screen.
*   **Non-Intrusive Styling**: We will use Tailwind CSS (based on your project's configuration) or custom CSS to ensure the chat UI is visually consistent with the dark theme from `ref-001` and does not block critical parts of the 3D scene.
*   **Independent JavaScript**: A new `<script>` tag or a separate JS file will manage the chat's functionality (sending/receiving messages). It will operate independently of the Three.js `animate()` loop, only communicating with it when an `action` needs to be triggered.

## 3. Proposed Architecture: AWS Serverless

This is the step-by-step plan we discussed, which is ideal for a novice coder as it avoids managing servers.

**Workflow:**
`User -> Chat UI -> API Gateway -> Lambda -> Lex -> Lambda -> API Gateway -> Chat UI (triggers 3D action)`

*   **Phase 1: Backend Foundation**
    1.  **Create Lambda Function**: In the AWS console, create a new Lambda function using a Python runtime.
    2.  **Create API Gateway**: Create a new REST API. Define a `/chat` resource with a `POST` method.
    3.  **Connect API to Lambda**: Configure the `POST` method to trigger your Lambda function. Grant the necessary permissions.
    4.  **Deploy API**: Deploy the API to get a public URL. We will use this URL in the frontend.

*   **Phase 2: Intent Recognition with Amazon Lex**
    1.  **Create Lex Bot**: In the Amazon Lex console, create a new bot.
    2.  **Define Intents**: Create intents that match desired user actions (e.g., `ShowProjects`, `ExplainTechnology`, `ContactInfo`).
    3.  **Add Utterances**: For each intent, provide sample phrases a user might say (e.g., for `ShowProjects`: "show me your work", "what have you built?").
    4.  **Integrate with Lambda**: Update the Lambda function's code and IAM role to allow it to call the Lex bot. The Lambda will pass the user's message to Lex and get the identified intent in return.

*   **Phase 3: Frontend Integration & Actions**
    1.  **Build Chat UI**: Add the HTML/CSS for the chat window to `index.html`.
    2.  **Implement `fetch`**: Write JavaScript to take the user's input, send it to the API Gateway URL, and display the response.
    3.  **Create Action Handler**: Write a JavaScript function (e.g., `handleChatAction(action)`) that takes a command from the backend's response (e.g., `"highlight_model"`) and executes the corresponding Three.js code.

*   **Phase 4: Contextual Content with Amazon Kendra (Optional)**
    1.  **Create Kendra Index**: In the Kendra console, create a new index.
    2.  **Add Data Source**: Upload your documents (e.g., project details, blog posts) or connect a data source like an S3 bucket.
    3.  **Integrate with Lambda**: Update the Lambda function to query the Kendra index when the user's intent is to ask a question.

## 4. Alternative Strategies

Here are other options to consider:

*   **Alternative Cloud Providers**:
    *   **Google Cloud**: Use **Dialogflow** (for intent recognition, like Lex) and **Cloud Functions** (like Lambda). The architecture is very similar.
    *   **Microsoft Azure**: Use **Azure Bot Service** and **Azure Functions**.

*   **Self-Hosted/Open-Source**:
    *   **Rasa**: A very powerful open-source framework for building chatbots. It gives you maximum control but requires you to manage the hosting (e.g., on an EC2 server) and has a steeper learning curve.

*   **Simplified Real-time Approach (More Advanced)**:
    *   **WebSocket API**: Instead of a REST API, we could use a WebSocket API with API Gateway and Lambda. This provides a persistent, two-way connection, which is more efficient for a chat application than repeated HTTP requests. However, it's slightly more complex to manage the connection state.

## 5. Recommendation

For your goals and experience level, the **proposed AWS Serverless architecture is the best starting point**. It's scalable, cost-effective (you only pay per request), and lets you focus on the logic without worrying about servers. We can build it piece by piece, ensuring each part works before moving to the next.

---

How does this detailed plan look to you? We can adjust it based on your feedback before we begin implementation.
