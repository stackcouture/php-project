<?php include 'inc/header.php'; ?>
<style> 
.main {
    width: 80%;
    margin: 0 auto;
    padding: 20px;
}

.content {
    padding: 20px;
    background-color: #f4f4f4;
}

.section group {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.about-info {
    background: #fff;
    padding: 15px;
    border-radius: 5px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

h2 {
    font-size: 30px;
    color: #333;
}

h3 {
    font-size: 22px;
    margin-bottom: 10px;
    color: #555;
}

p {
    font-size: 16px;
    line-height: 1.5;
    color: #666;
}

ul {
    list-style-type: disc;
    padding-left: 20px;
}

ul li {
    font-size: 16px;
    color: #555;
}

a {
    color: #0066cc;
    text-decoration: none;
}

a:hover {
    text-decoration: underline;
}

</style>
<div class="main">
    <div class="content">
        <div class="section group">
            <h2>About Us</h2>
            <p>Welcome to our website! We are a company committed to providing high-quality services and products. Here’s a little about us:</p>

            <div class="about-info">
                <h3>Our Mission</h3>
                <p>Our mission is to revolutionize the industry with innovative solutions that improve the lives of our customers. We believe in delivering value, building trust, and fostering long-term relationships with our clients.</p>
            </div>

            <div class="about-info">
                <h3>Our Vision</h3>
                <p>We aim to be the market leader in our field, providing our customers with top-notch services and products that exceed expectations. We strive to maintain a work environment that fosters creativity and excellence.</p>
            </div>

            <div class="about-info">
                <h3>Our Values</h3>
                <ul>
                    <li>Integrity: We adhere to the highest standards of honesty and transparency.</li>
                    <li>Customer-centricity: We put our customers first in everything we do.</li>
                    <li>Innovation: We are constantly evolving and innovating to stay ahead of the curve.</li>
                    <li>Teamwork: We believe in working together to achieve common goals.</li>
                </ul>
            </div>

            <div class="about-info">
                <h3>Our Team</h3>
                <p>Our team is composed of highly skilled professionals with a passion for delivering outstanding results. We work collaboratively to achieve our vision and mission, and we believe in continuous learning and growth.</p>
            </div>

            <div class="about-info">
                <h3>Contact Information</h3>
                <p>If you have any questions, feel free to reach out to us:</p>
                <p>Email: <a href="mailto:info@company.com">info@company.com</a></p>
                <p>Phone: 123-456-7890</p>
                <p>Address: 123 Company Street, City, Country</p>
            </div>
        </div>
    </div>
</div>

<?php include 'inc/footer.php'; ?>
